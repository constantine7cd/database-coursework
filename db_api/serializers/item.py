from rest_framework.serializers import ModelSerializer, PrimaryKeyRelatedField

from db_api.models import Item
from db_api.serializers.user import UserSerializer
from db_api.serializers.asset_bundle import AssetBundleSerializer

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