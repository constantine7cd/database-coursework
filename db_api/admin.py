from django.contrib import admin
from db_api.models import Profile, AssetBundle, Asset, Item, Comment, Like

class ItemAdmin(admin.ModelAdmin):

    list_display = ['owner', 'asset_bundle', 'created_at']

admin.site.register(Item, ItemAdmin)


class ProfileAdmin(admin.ModelAdmin):

    list_display = ['user']

admin.site.register(Profile, ProfileAdmin)


class AssetBundleAdmin(admin.ModelAdmin):

    list_display = ['name', 'kind']


admin.site.register(AssetBundle, AssetBundleAdmin)


class AssetAdmin(admin.ModelAdmin):

    list_display = ['kind', 'extension', 'url']


admin.site.register(Asset, AssetAdmin)


class CommentAdmin(admin.ModelAdmin):
    list_display = ['item', 'owner', 'body']


admin.site.register(Comment, CommentAdmin)

class LikeAdmin(admin.ModelAdmin):
    pass


admin.site.register(Like, LikeAdmin)
