FIREBASE_URL_BASE = 'https://www.gstatic.com/firebasejs/9.14.0'

async function twitterLogin() {
    var userData = {};
    var userId;

    import(FIREBASE_URL_BASE+'/firebase-auth.js').then((module) => {
        const provider = new module.TwitterAuthProvider();
        const auth = module.getAuth();
        return module.signInWithPopup(auth, provider).catch((error) => {
            alert('twitter認証エラー. エラーコード' + error.code)
        })
    }).then((result) => {
        userId = result.user.uid;
        userData = {
            name: result._tokenResponse.fullName,
            photo: result._tokenResponse.photoUrl,
            greeting: 'よろしくお願いします。',
            tags: [],
            twitterId: result._tokenResponse.screenName,
            blocks: [],
            times: [],
            // twitter_token: result._tokenResponse.oauthAccessToken,
            // twitter_secret: result._tokenResponse.oauthTokenSecret,
        }
        return import(FIREBASE_URL_BASE+'/firebase-firestore.js')
    }).then((module) => {
        userData.updatedAt = module.serverTimestamp()
        userRef = module.doc(module.getFirestore(), 'User', userId)
        module.setDoc(userRef, userData, { merge: true}).catch((error) => {
            alert('ユーザーデータ登録エラー.' + error)
        })
    })
}

async function twitterLogout() {
    import(FIREBASE_URL_BASE+'/firebase-auth.js').then((module) => {
        const auth = module.getAuth();
        return auth.signOut().catch((error) => {
            alert('ログアウトエラー. エラー: ' + error)
        })
    })
}