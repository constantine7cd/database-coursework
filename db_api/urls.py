from django.conf.urls import include, url
from .views import item_list, item_detail

urlpatterns = [
    url(r'^items/?$', item_list, name='item-list'),
    url(r'^items/(?P<pk>[0-9]+)/?$', item_detail, name='item-detail'),
]
