from django.db import IntegrityError
from rest_framework import status, generics, mixins
from rest_framework.response import Response

from db_api.models import Item, AssetBundle, Like, Comment
from db_api.serializers.item import ItemSerializer, ItemDetailSerializer
from db_api.serializers.asset_bundle import AssetBundleSerializer, AssetBundleDetailSerializer
from db_api.db_settings import CONSUMER_PERMS

import json


class ItemList(generics.ListCreateAPIView):
    """
    Item: Create, List
    """

    queryset = Item.objects.all()
    serializer_class = ItemSerializer
    permission_classes = CONSUMER_PERMS


class ItemDetail(generics.RetrieveUpdateDestroyAPIView):
    """
    Location: Read, Write, Delete
    """

    queryset = Item.objects.all()
    serializer_class = ItemDetailSerializer
    permission_classes = CONSUMER_PERMS


class AssetBundleList(generics.ListCreateAPIView):
    """
    Item: Create, List
    """

    queryset = AssetBundle.objects.all()
    serializer_class = AssetBundleSerializer
    permission_classes = CONSUMER_PERMS

class AssetBundleDetail(generics.RetrieveUpdateDestroyAPIView):
    """
    Location: Read, Write, Delete
    """

    queryset = AssetBundle.objects.all()
    serializer_class = AssetBundleDetailSerializer
    permission_classes = CONSUMER_PERMS


class LikeItem(generics.CreateAPIView):

    def post(self, request):
        data = json.loads(request.body.decode('utf-8'))

        if not 'item_id' in data:
            return Response({'error': 'no item_id in request.'}, status=status.HTTP_400_BAD_REQUEST)

        item = Item.objects.get(pk=data['item_id'])

        try:
            like = Like()
            like.item = item
            like.owner = request.user
            like.save()
        except IntegrityError:
            return Response({'error': 'this item has already been liked by this user'}, status=status.HTTP_400_BAD_REQUEST)


        serializer = ItemDetailSerializer(item)
        return Response(serializer.data, status=status.HTTP_200_OK)

class CommentItem(generics.CreateAPIView):

    def post(self, request):
        data = json.loads(request.body.decode('utf-8'))

        if not 'item_id' in data:
            return Response({'error': 'no item_id in request.'}, status=status.HTTP_400_BAD_REQUEST)

        if not 'body' in data:
            return Response({'error': 'no body in request.'}, status=status.HTTP_400_BAD_REQUEST)

        item = Item.objects.get(pk=data['item_id'])

        comment = Comment()
        comment.item = item
        comment.body = data['body']
        comment.owner = request.user
        comment.save()

        serializer = ItemDetailSerializer(item)
        return Response(serializer.data, status=status.HTTP_200_OK)
