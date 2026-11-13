
from django.http import HttpResponse


def home(request):
    return HttpResponse("""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport"
              content="width=device-width, initial-scale=1">
        <title>My Django Website</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f3f6fb;
                text-align: center;
                padding: 80px 20px;
            }
            .card {
                background: white;
                padding: 40px;
                border-radius: 16px;
                max-width: 550px;
                margin: auto;
                box-shadow: 0 8px 30px #00000010;
            }
            h1 { color: #1d4ed8; }
            p { color: #475569; }
        </style>
    </head>
    <body>
        <div class="card">
            <h1>Welcome to My Django Website!</h1>
            <p>Python Django is working successfully.</p>
            <p>Environment: Staging</p>
             <p>Environment: 
             </p>
        </div>
    </body>
    </html>
    """)
