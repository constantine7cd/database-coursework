from django.conf.urls import include, url
from .views import ItemList, ItemDetail, AssetBundleList, AssetBundleDetail, LikeItem, CommentItem

urlpatterns = [
    url(r'^items/?$', ItemList.as_view(), name='item-list'),
    url(r'^items/(?P<pk>[0-9]+)/?$', ItemDetail.as_view(), name='item-detail'),
    url(r'^asset-bundles/?$', AssetBundleList.as_view(), name='asset-bundles-list'),
    url(r'^asset-bundles/(?P<pk>[0-9]+)/?$', AssetBundleDetail.as_view(), name='asset-bundles-detail'),
    url(r'^like/?$', LikeItem.as_view(), name='like'),
    url(r'^comment/?$', CommentItem.as_view(), name='comment'),
]
