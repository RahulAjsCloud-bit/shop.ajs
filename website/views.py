
from django.http import HttpResponse
from django.contrib.staticfiles.storage import staticfiles_storage
from html import escape


def home(request):
    logo = escape(staticfiles_storage.url("website/ajs-logo.png"))
    hero = escape(staticfiles_storage.url("website/store-hero.jpg"))
    preview = escape(staticfiles_storage.url("website/store-preview.jpg"))

    return HttpResponse(f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>AJS Cloud - Store</title>

        <style>
            * {{
                box-sizing: border-box;
            }}

            body {{
                margin: 0;
                font-family: Arial, sans-serif;
                color: #252525;
                background: white;
            }}

            .topbar {{
                background: #141638;
                color: white;
                padding: 18px 20px;
                text-align: center;
            }}

            .topbar a {{
                color: white;
                margin: 0 16px;
                text-decoration: underline;
            }}

            .navbar {{
                max-width: 1120px;
                margin: auto;
                min-height: 140px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 20px;
            }}

            .logo {{
                width: 190px;
                height: auto;
            }}

            .nav-links {{
                display: flex;
                gap: 35px;
            }}

            .nav-links a {{
                color: #252525;
                text-decoration: none;
                font-size: 18px;
            }}

            .hero {{
                height: 435px;
                background-image:
                    linear-gradient(
                        rgba(18, 38, 65, 0.65),
                        rgba(18, 38, 65, 0.65)
                    ),
                    url("{hero}");
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: center;
            }}

            .hero-content {{
                width: 1120px;
                margin: auto;
                padding: 20px;
                text-align: right;
                color: white;
            }}

            .hero h1 {{
                font-size: 60px;
                margin: 0 0 15px;
            }}

            .hero p {{
                font-size: 20px;
            }}

            .content {{
                max-width: 1120px;
                margin: 110px auto;
                padding: 20px;
                text-align: center;
            }}

            .content img {{
                width: 100%;
                height: auto;
            }}

            @media (max-width: 768px) {{
                .navbar {{
                    flex-direction: column;
                    gap: 20px;
                    min-height: 120px;
                }}

                .nav-links {{
                    flex-wrap: wrap;
                    justify-content: center;
                    gap: 15px;
                }}

                .hero h1 {{
                    font-size: 42px;
                }}

                .hero {{
                    height: 300px;
                }}
            }}
        </style>
    </head>

    <body>
        <div class="topbar">
            <a href="mailto:sales@ajscloud.com">
                ✉ sales@ajscloud.com
            </a>
            <a href="tel:+14085331820">
                ☎ +1-408-533-1820
            </a>
        </div>

        <header class="navbar">
            <img src="{logo}"
                 alt="AJS Cloud"
                 class="logo">

            <nav class="nav-links">
                <a href="/">Home</a>
                <a href="#">Hire Developers</a>
                <a href="#">Store</a>
                <a href="#">My account</a>
            </nav>
        </header>

        <section class="hero">
            <div class="hero-content">
                <h1>Store</h1>
                <p>Home / Store</p>
            </div>
        </section>

        <section class="content">
            <img src="{preview}"
                 alt="AJS Cloud Store">
        </section>
          <section class="content">
            <img src="{preview}"
                 alt="AJS Cloud gfhdfgh">
        </section>
    </body>
    </html>
    """)
