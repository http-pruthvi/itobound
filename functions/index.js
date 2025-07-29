const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Helper: Zodiac compatibility (simplified)
const zodiacCompatibility = {
  'Aries': ['Leo', 'Sagittarius', 'Gemini', 'Aquarius'],
  'Taurus': ['Virgo', 'Capricorn', 'Cancer', 'Pisces'],
  'Gemini': ['Libra', 'Aquarius', 'Aries', 'Leo'],
  'Cancer': ['Scorpio', 'Pisces', 'Taurus', 'Virgo'],
  'Leo': ['Aries', 'Sagittarius', 'Gemini', 'Libra'],
  'Virgo': ['Taurus', 'Capricorn', 'Cancer', 'Scorpio'],
  'Libra': ['Gemini', 'Aquarius', 'Leo', 'Sagittarius'],
  'Scorpio': ['Cancer', 'Pisces', 'Virgo', 'Capricorn'],
  'Sagittarius': ['Aries', 'Leo', 'Libra', 'Aquarius'],
  'Capricorn': ['Taurus', 'Virgo', 'Scorpio', 'Pisces'],
  'Aquarius': ['Gemini', 'Libra', 'Aries', 'Sagittarius'],
  'Pisces': ['Cancer', 'Scorpio', 'Taurus', 'Capricorn'],
};

function calculateCompatibility(userA, userB) {
  // Zodiac match bonus
  let score = 50;
  if (zodiacCompatibility[userA.zodiacSign]?.includes(userB.zodiacSign)) {
    score += 20;
  }
  // Shared interests
  const shared = userA.interests?.filter(i => userB.interests?.includes(i)) || [];
  score += Math.min(shared.length * 5, 20);
  // Clamp
  return Math.min(score, 100);
}

// Cloud Function: Trigger on swipe creation
exports.onSwipeCreate = functions.firestore
  .document('swipes/{swipeId}')
  .onCreate(async (snap, context) => {
    const swipe = snap.data();
    if (swipe.action !== 'like') return null;
    const { swiperId, targetId } = swipe;
    // Check if the other user liked back
    const theirLikeSnap = await admin.firestore().collection('swipes')
      .where('swiperId', '==', targetId)
      .where('targetId', '==', swiperId)
      .where('action', '==', 'like')
      .get();
    if (!theirLikeSnap.empty) {
      // Fetch user profiles
      const [userA, userB] = await Promise.all([
        admin.firestore().collection('users').doc(swiperId).get(),
        admin.firestore().collection('users').doc(targetId).get(),
      ]);
      const userAData = userA.data();
      const userBData = userB.data();
      // Calculate compatibility
      const compatibilityScore = calculateCompatibility(userAData, userBData);
      // Create match document
      const matchId = `${swiperId}_${targetId}`;
      await admin.firestore().collection('matches').doc(matchId).set({
        matchId,
        userA: swiperId,
        userB: targetId,
        compatibilityScore,
        matchedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
    return null;
  });

// Cloud Function: Send FCM notification on new message
exports.onMessageCreate = functions.firestore
  .document('messages/{messageId}')
  .onCreate(async (snap, context) => {
    const message = snap.data();
    const receiverId = message.receiverId;
    // Get receiver's FCM token
    const userDoc = await admin.firestore().collection('users').doc(receiverId).get();
    const fcmToken = userDoc.data().fcmToken;
    if (!fcmToken) return null;
    // Send notification
    const payload = {
      notification: {
        title: 'New Message',
        body: message.text ? message.text : 'You have a new message!',
      },
      token: fcmToken,
    };
    await admin.messaging().send(payload);
    return null;
  }); 