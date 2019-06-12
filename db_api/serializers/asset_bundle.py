from rest_framework.serializers import ModelSerializer, PrimaryKeyRelatedField

from db_api.models import AssetBundle
from db_api.serializers.user import UserSerializer

class AssetBundleSerializer(ModelSerializer):

    owner = PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = AssetBundle
        fields = (
            'id',
            'name',
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
            'name',
            'kind',
            'base_url',
            'owner',
            'asset_urls',
            'created_at',
            'updated_at',
        )
        read_only_fields = ('id',)