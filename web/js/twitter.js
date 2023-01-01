FIREBASE_URL_BASE = 'https://www.gstatic.com/firebasejs/9.14.0'

async function twitterLogin() {
    var userData = {};

    import(FIREBASE_URL_BASE+'/firebase-auth.js').then((module) => {
        const provider = new module.TwitterAuthProvider();
        const auth = module.getAuth();
        return module.signInWithPopup(auth, provider).catch((error) => {
            alert('twitter認証エラー. エラーコード' + error.code)
        })
    }).then((result) => {
        userData = {
            id: result.user.uid,
            name: result._tokenResponse.fullName,
            photo: result._tokenResponse.photoUrl,
            tags: [],
            twitterId: result._tokenResponse.screenName,
            // twitter_token: result._tokenResponse.oauthAccessToken,
            // twitter_secret: result._tokenResponse.oauthTokenSecret,
        }
        return import(FIREBASE_URL_BASE+'/firebase-firestore.js')
    }).then((module) => {
        userData.updatedAt = module.serverTimestamp()
        userRef = module.doc(module.getFirestore(), 'user', userData.id)
        module.setDoc(userRef, userData, { merge: true}).catch((error) => {
            alert('ユーザーデータ登録エラー.' + error)
        })
    })
}
