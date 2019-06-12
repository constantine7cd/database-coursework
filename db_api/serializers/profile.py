from rest_framework.serializers import ModelSerializer

from db_api.models import Profile


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