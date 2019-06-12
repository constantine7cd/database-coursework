from django.contrib.auth.models import User
from django.contrib.auth import get_user_model
from rest_framework.serializers import ModelSerializer, PrimaryKeyRelatedField, SerializerMethodField

from .models import Item, AssetBundle, Asset, Comment, Like, Profile

User = get_user_model()

class ProfileSerializer(ModelSerializer):

    """
    Profile Detail Serializer
    """

    class Meta:
        model = Profile
        fields = (
            'id',
            'website_url'
        )
        read_only_fields = ('id',)

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

class AssetBundleSerializer(ModelSerializer):

    owner = PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = AssetBundle
        fields = (
            'id',
            'salt',
            'kind',
            'base_url',
            'owner',
            'created_at',
        )
        read_only_fields = ('id',)

class AssetBundleDetailSerializer(ModelSerializer):

    owner = UserSerializer(read_only=True)

    class Meta:
        model = AssetBundle
        fields = (
            'id',
            'salt',
            'kind',
            'base_url',
            'owner',
            'asset_urls',
            'created_at',
            'updated_at',
        )
        read_only_fields = ('id',)

class ItemSerializer(ModelSerializer):

    owner = PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = Item
        fields = (
            'id',
            'asset_bundle',
            'owner',
            'created_at'
        )
        read_only_fields = ('id',)

class ItemDetailSerializer(ModelSerializer):

    owner = UserSerializer(read_only=True)
    asset_bundle = AssetBundleSerializer(read_only=True)

    class Meta:
        model = Item
        fields = (
            'id',
            'asset_bundle',
            'owner',
            'likes_count',
            'likes',
            'comments_count',
            'comments',
            'created_at',
            'updated_at',
        )
        read_only_fields = ('id',)



