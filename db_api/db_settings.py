from rest_framework.permissions import AllowAny, IsAuthenticated, DjangoModelPermissions

CONSUMER_PERMS = [
    IsAuthenticated
]

UNPROTECTED = [
    AllowAny
]