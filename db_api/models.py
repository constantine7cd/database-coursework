from django.db import models
from django.contrib.auth.models import User

from imagenetwork.settings import BASE_URL

class Profile(models.Model):

    ROLES = (
        ('consumer', 'consumer'),
        ('staff', 'staff')
    )

    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.TextField(blank=True, null=True)
    website_url = models.CharField(blank=True, null=True, max_length=100)
    role = models.CharField(max_length=8, choices=ROLES)

class AssetBundle(models.Model):

    KINDS = (
        ('image', 'image'),
        ('video', 'video')
    )

    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    name = models.CharField(max_length=20)
    kind = models.CharField(max_length=5, choices=KINDS, default='image')
    base_url = models.CharField(max_length=100, default=BASE_URL)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    @property
    def asset_urls(self):
        return { a.kind: a.url for a in Asset.objects.filter(asset_bundle=self)}


class Asset(models.Model):
    
    KINDS = (
        ('large', 'large'),
        ('original', 'original'),
        ('small', 'small')
    )

    EXTS = (
        ('jpg', 'jpg'),
        ('png', 'png'),
        ('jpeg', 'jpeg')
    )

    asset_bundle = models.ForeignKey(AssetBundle, on_delete=models.CASCADE)
    kind = models.CharField(max_length=8, choices=KINDS, default='original')
    width = models.IntegerField(default=0)
    height = models.IntegerField(default=0)
    extension = models.CharField(max_length=4, choices=EXTS)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    @property
    def url(self):
        return "%s%s/%s_%s.%s" % (self.asset_bundle.base_url, self.asset_bundle.kind, \
            self.asset_bundle.name, self.kind, self.extension)


class Item(models.Model):

    asset_bundle = models.ForeignKey(AssetBundle, on_delete=models.CASCADE)

    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    @property
    def likes_count(self):
        return Like.objects.filter(item_id=self.id).count()

    @property
    def likes(self):
        return [ like.owner.username for like in Like.objects.filter(item_id=self.id)]

    @property
    def comments_count(self):
        return Comment.objects.filter(item_id=self.id).count()

    @property
    def comments(self):
        return [ { 'body': c.body, 'username': c.username, 'created_at': c.created_at } for c in Comment.objects.filter(item_id=self.id)]

    
class Comment(models.Model):
    
    item = models.ForeignKey(Item, on_delete=models.CASCADE)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    body = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Like(models.Model):

    item = models.ForeignKey(Item, on_delete=models.CASCADE)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('item', 'owner')

    

