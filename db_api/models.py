from django.db import models
from django.contrib.auth.models import User

class Item(models.Model):


    title = models.CharField(max_length=255)
    subtitle = models.CharField(max_length=255, blank=True, null=True)
    like_count = models.IntegerField(default=0)

    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    @property
    def full_title(self):
        return "%s: %s" % (self.title, self.subtitle)

    def __unicode__(self):
        return self.title
