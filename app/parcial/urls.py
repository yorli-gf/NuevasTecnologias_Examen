from django.urls import path
from django.http import HttpResponse

def home(request):
    html = """
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Parcial 1</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
                color: white;
                height: 100vh;
                margin: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                text-align: center;
            }
            .container {
                background: rgba(255, 255, 255, 0.1);
                padding: 3rem;
                border-radius: 20px;
                backdrop-filter: blur(10px);
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                border: 1px solid rgba(255, 255, 255, 0.18);
            }
            h1 { font-size: 3.5rem; margin-bottom: 0.5rem; }
            p { font-size: 1.5rem; opacity: 0.9; }
            .badge {
                background: #ffcc00;
                color: #333;
                padding: 0.5rem 1.5rem;
                border-radius: 50px;
                font-weight: bold;
                display: inline-block;
                margin-top: 1rem;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Parcial 1</h1>
            <p>Yorli Gonzalez</p>
            <div class="badge">AWS ECS Fargate + Django</div>
        </div>
    </body>
    </html>
    """
    return HttpResponse(html)

urlpatterns = [
    path('', home),
]
