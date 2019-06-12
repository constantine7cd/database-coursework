from django.contrib.auth import get_user_model
from rest_framework.serializers import ModelSerializer

from db_api.serializers.profile import ProfileSerializer

User = get_user_model()

class UserSerializer(ModelSerializer):

    profile = ProfileSerializer(many=False)

    class Meta:
        model = User
        fields = (
            'id',
            User.USERNAME_FIELD,
            'first_name',
            'last_name',
            'email',
            'profile',
        )
        read_only_fields = (
            'id',   
            'profile',
        )

class UserDetailSerializer(ModelSerializer):
    """
    User Detail Serializer
    """


    class Meta:
        model = User
        fields = (
            'id',
            User.USERNAME_FIELD,
            'first_name',
            'last_name',
            'email',
            'groups',
        )
        read_only_fields = fields


class UserListSerializer(ModelSerializer):
    """
    User List Serializer
    """

    class Meta:
        model = User
        fields = (
            'id',
            User.USERNAME_FIELD,
            'first_name',
            'last_name',
            'email',
        )
        read_only_fields = fields