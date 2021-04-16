class CookieBar {
    constructor() {
        this.cookiesBar = document.getElementById('cookies-bar');
    }

    init() {
        if (this.cookiesAllowed()) {
            this.appendGACode();
        }

        this.addButtonBehaviors();
    }

    cookiesAllowed() {
        return Cookies.get('allow_cookies') === 'yes';
    }

    addButtonBehaviors() {
        if (!this.cookiesBar) {
            return;
        }

        this.cookiesBar.querySelector('.accept').addEventListener('click', () => this.allowCookies(true));

    }


    allowCookies(allow) {
        if (allow) {
            Cookies.set('allow_cookies', 'yes', {
                expires: 365
            });

            this.appendGACode();
        }
        this.cookiesBar.classList.add('hidden');
    }
}

window.onload = function() {
    const cookieBar = new CookieBar();

    cookieBar.init();
}