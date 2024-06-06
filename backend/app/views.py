# app/views.py
from rest_framework import viewsets
from rest_framework import generics
from rest_framework.response import Response
from rest_framework import status
from .models import AdvertisingLocation, Advertiser, Advertisement, AdSpend
from .serializers import AdvertisingLocationSerializer, AdvertiserSerializer, AdvertisementSerializer, AdSpendSerializer, UserRegistrationSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import SessionAuthentication, BasicAuthentication

class AdvertisingLocationViewSet(viewsets.ModelViewSet):
    queryset = AdvertisingLocation.objects.all()
    serializer_class = AdvertisingLocationSerializer
    # permission_classes = [IsAuthenticated]

class AdvertiserViewSet(viewsets.ModelViewSet):
    queryset = Advertiser.objects.all()
    serializer_class = AdvertiserSerializer
    # permission_classes = [IsAuthenticated]

class AdvertisementViewSet(viewsets.ModelViewSet):
    queryset = Advertisement.objects.all()
    serializer_class = AdvertisementSerializer
    # permission_classes = [IsAuthenticated]

class AdSpendViewSet(viewsets.ModelViewSet):
    queryset = AdSpend.objects.all()
    serializer_class = AdSpendSerializer
    # permission_classes = [IsAuthenticated]


class UserRegistrationView(generics.CreateAPIView):
    serializer_class = UserRegistrationSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            user_data = serializer.save()
            return Response(user_data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)