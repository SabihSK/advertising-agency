# app/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import AdvertisingLocationViewSet, AdvertiserViewSet, AdvertisementViewSet, AdSpendViewSet, UserRegistrationView

router = DefaultRouter()
router.register('advertising-locations', AdvertisingLocationViewSet)
router.register('advertisers', AdvertiserViewSet)
router.register('advertisements', AdvertisementViewSet)
router.register('adspends', AdSpendViewSet)




urlpatterns = [
    path('', include(router.urls)),
    path('register/', UserRegistrationView.as_view(), name='register'),
]
