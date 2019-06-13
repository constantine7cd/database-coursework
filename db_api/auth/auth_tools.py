from django.core import signing
from django.urls import reverse
from django.core.validators import validate_email
from django.core.exceptions import ObjectDoesNotExist, ValidationError
from django.contrib.auth import login, logout, authenticate
from django.contrib.auth.models import User, Group
from django.conf import settings as django_settings

from rest_framework.authtoken.models import Token

from db_api.models import Profile
from db_api.auth.settings import MIN_PASSWORD_LENGTH, MIN_USERNAME_LENGTH, RE_VALIDATE_USERNAME
import re

class Auth:

    @staticmethod
    def auth_by_username(username, password):

        try:
            user = authenticate(username=username, password=password)

            if user is not None:
                return user
        except:
            pass

        return None

    @staticmethod
    def auth_by_email(email, password):

        if re.match(r'[^@]+@[^@]+\.[^@]+', email):

            user = Auth.get_user_by_email(email)

            if user is not None:
                return Auth.auth_by_username(user.username, password)
            else:
                return Auth.auth_by_username(email, password)

        return None

    @staticmethod
    def get_user_by_email(email):

        if email:
            try:
                user = User.objects.filter(email=email, is_active=True)[0]
                return user
            except:
                pass

        return None

    @staticmethod
    def get_user_by_username(username):

        try:
            user = User.objects.filter(username=username, is_active=True)[0]
            return user
        except:
            pass

        return None

    @staticmethod 
    def issue_user_token(user, salt):
        """
            Issue token for user
		"""

        if user is not None:
            if (salt == 'login'):
                token, _ = Token.objects.get_or_create(user=user)
            else:
                token = signing.dumps({'pk': user.pk}, salt=salt)

            return token

        return None


    @staticmethod
    def login(request, user):

        if user is not None:
            try:
                login(request, user)
                return True
            except:
                # We can handle exception with message
                pass
        return False

    @staticmethod
    def logout(request):

        if request:
            try:
                Token.objects.filter(user=request.user).delete()
                logout(request)
                return True
            except Exception as e:
                pass

        return False

    @staticmethod
    def register(user_data, profile_data, group):
        """
            Register user:

            user_data = {'username', 'email', 'password'}
            profile_data = {'role', 'position'}
		"""

        try:
            user_exists = User.objects.filter(email=user_data['email'])
            if user_exists:
                return {
					'user': user_exists[0],
					'is_new': False
				}

            username_exists = User.objects.filter(username=user_data['username'])
            if username_exists:
                return {
					'user': username_exists[0],
					'is_new': False
				}

            user = User.objects.create_user(**user_data)

            profile_data['user'] = user
            profile = Profile(**profile_data)
            profile.save()

            group = Group.objects.get(name=group)
            group.user_set.add(user)

            return {
                'user': user,
                'is_new': True
            }
        except Exception as e:
            raise Exception(e.message)

        return None

    @staticmethod
    def profile_register(user, profile_data):
        """
            Register user profile:
            profile_data = {'role', 'position'}
        """

        try:
            return Profile.objects.get(pk=user.id)
        except ObjectDoesNotExist:
            try:
                profile_data['user'] = user
                profile = Profile(**profile_data)
                profile.save()

                group = Group.objects.get(name=profile_data['role'] + '_basic')
                group.user_set.add(user)

                return profile
            except:
                pass

        return None


    @staticmethod
    def set_password(user, password, new_password):
        """
        Set user's password
        """

        if user.has_usable_password():
            if user.check_password(password) and password != new_password:
                user.set_password(new_password)
                user.save()
                return True
        elif new_password:
            user.set_password(new_password)
            user.save()
            return True

        return False


    @staticmethod
    def validate_username(username):
        """
        Validate that the username is formatted and unique
        """

        stats = 'valid'

        if len(username) < MIN_USERNAME_LENGTH:
            stats = 'invalid'
        elif re.match(RE_VALIDATE_USERNAME, username) is None:
            stats = 'invalid'
        else:
            user = Auth.get_user_by_username(username)

            if user is not None:
                stats = 'taken'

        return stats


    @staticmethod
    def validate_email(email):
        """
        Validate the email is formatted and unique
        """

        status = 'valid'

        try:
            validate_email(email)
            user = Auth.get_user_by_email(email)

            if user is not None:
                status = 'taken'

        except:
            status = 'invalid'

        return status


    @staticmethod
    def validate_password(password):
        """
        Validate the password
        """
        rules = [
            lambda s: any(x.isupper() for x in s),     # must have at least one uppercase
            lambda s: any(x.islower() for x in s),     # must have at least one lowercase
            lambda s: any(x.isdigit() for x in s),     # must have at least one digit
            lambda s: len(s) >= MIN_PASSWORD_LENGTH    # must be at least min characters
        ]

        if all(rule(password) for rule in rules):
            return True

        return False

        

    