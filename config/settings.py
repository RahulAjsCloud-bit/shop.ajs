
from pathlib import Path
import os
# export DJANGO_SECRET_KEY='(d*qcmgzl^h5h1c3()nu0*sgqp1^qa1r^9164m)e-5zh1evmis'
# export DJANGO_DEBUG=True
# Base directory
BASE_DIR = Path(__file__).resolve().parent.parent

# Security configuration
SECRET_KEY = os.environ.get("DJANGO_SECRET_KEY", "")

if not SECRET_KEY:
    raise RuntimeError(
        "DJANGO_SECRET_KEY environment variable is required."
    )

# Enable debugging only in local development
DEBUG = os.environ.get("DJANGO_DEBUG", "False").lower() == "true"

# Allowed hosts
ALLOWED_HOSTS = [
    "localhost",
    "127.0.0.1",
    ".app.github.dev",
]

# CSRF configuration
CSRF_TRUSTED_ORIGINS = []

codespace_name = os.environ.get("CODESPACE_NAME")

if codespace_name:
    CSRF_TRUSTED_ORIGINS.append(
        f"https://{codespace_name}-8000.app.github.dev"
    )

# Installed applications
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "website",
]

# Middleware
MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "config.urls"

# Templates
TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "config.wsgi.application"

# SQLite database for development
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "db.sqlite3",
    }
}

# Password validators
AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]

# Internationalization
LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True

# Static files
STATIC_URL = "static/"

# Default primary key
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"


STATIC_URL = "static/"

STATICFILES_DIRS = [
    BASE_DIR / "static",
]

