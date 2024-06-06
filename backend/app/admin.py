from django.contrib import admin
from django.contrib.auth.models import User
from django.contrib.auth.admin import UserAdmin

from .models import AdvertisingLocation, Advertiser, Advertisement, AdvertisementLocation, AdSpend

class AdvertisingLocationAdmin(admin.ModelAdmin):
    list_display = ['name', 'description']

class AdvertiserAdmin(admin.ModelAdmin):
    list_display = ['user', 'business_crypto']

class AdvertisementAdmin(admin.ModelAdmin):
    list_display = ['advertiser', 'title', 'description']

class AdvertisementLocationAdmin(admin.ModelAdmin):
    list_display = ['advertisement', 'location']

class AdSpendAdmin(admin.ModelAdmin):
    list_display = ['advertisement', 'amount', 'date']

admin.site.register(AdvertisingLocation, AdvertisingLocationAdmin)
admin.site.register(Advertiser, AdvertiserAdmin)
admin.site.register(Advertisement, AdvertisementAdmin)
admin.site.register(AdvertisementLocation, AdvertisementLocationAdmin)
admin.site.register(AdSpend, AdSpendAdmin)

# admin.site.unregister(User)
# admin.site.register(User, UserAdmin) 
