from django.contrib.auth import get_user_model
from django.conf import settings as dj_settings
from rest_framework import status, generics
from rest_framework.response import Response

from db_api.auth.auth_tools import Auth

from db_api.db_settings import CONSUMER_PERMS, UNPROTECTED
from db_api.serializers.user import UserSerializer
from db_api.serializers.profile import ProfileSerializer
from db_api.auth.serializers import LoginSerializer, UserRegisterSerializer, LoginCompleteSerializer, LogoutSerializer
from db_api.models import Profile
import re

User = get_user_model()

class UserView(generics.RetrieveUpdateAPIView):
    """
    User View
    """

    model = User
    serializer_class = UserSerializer
    permission_classes = CONSUMER_PERMS

    def get_object(self, *args, **kwargs):
        return self.request.user


class ProfileView(generics.RetrieveUpdateAPIView):
    """
    Profile View
    """

    model = User.profile
    serializer_class = ProfileSerializer
    permission_classes = CONSUMER_PERMS

    def get_object(self, *args, **kwargs):
        return self.request.user.profile


class LoginView(generics.GenericAPIView):
    """
    Login View
    """

    permission_classes = UNPROTECTED
    serializer_class = LoginSerializer

    def post(self, request):
        if 'email' in request.data and 'password' in request.data:
            
            
            email = request.data['email'].lower()
            password = request.data['password']

            user = Auth.auth_by_email(email, password)

            print("View user is None: ", user is None)

            if user is not None and Auth.login(request, user):
                token = Auth.issue_user_token(user, 'login')
                serializer = LoginCompleteSerializer(token)
                return Response(serializer.data)

        message = {'message': 'Unable to login with the credentials provided.'}
        return Response(message, status=status.HTTP_400_BAD_REQUEST)


class LogoutView(generics.GenericAPIView):
    """
    Logout View
    """

    permission_classes = CONSUMER_PERMS
    serializer_class = LogoutSerializer

    def post(self, request):
        if Auth.logout(request):
            data = {"logout": "success"}
            return Response(data, status=status.HTTP_200_OK)

        return Response(status=status.HTTP_400_BAD_REQUEST)


class RegisterView(generics.CreateAPIView):
    """
    Register View
    """

    serializer_class = UserRegisterSerializer
    permission_classes = UNPROTECTED

    def perform_create(self, serializer):
        instance = serializer.save()
