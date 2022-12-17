async function twitterLogin() {
    import('https://www.gstatic.com/firebasejs/9.14.0/firebase-auth.js').then((module) => {
        const provider = new module.TwitterAuthProvider();
        const auth = module.getAuth();
        return module.signInWithPopup(auth, provider)
    }).then((result) => {
        const response = {
            id: result.user.uid,
            name: result._tokenResponse.fullName,
            photo: result._tokenResponse.photoUrl,
            twitterId: result._tokenResponse.screenName,
            // twitter_token: result._tokenResponse.oauthAccessToken,
            // twitter_secret: result._tokenResponse.oauthTokenSecret,
        }
        // return response 
    }).catch((error) => {
        // Handle Errors here.
        const errorCode = error.code;
        const errorMessage = error.message;
        // The email of the user's account used.
        const email = error.customData.email;
        // The AuthCredential type that was used.
        const credential = module.TwitterAuthProvider.credentialFromError(error);
        
        alert('twitter認証エラー. エラーコード' + errorCode)
    });
}
