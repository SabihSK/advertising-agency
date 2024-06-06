from rest_framework import serializers
from django.contrib.auth.models import User
from django.db import IntegrityError
from django.db.models import Sum
from rest_framework.authtoken.models import Token  # Add this import
from .models import AdvertisingLocation, Advertiser, Advertisement, AdvertisementLocation, AdSpend

class AdvertisingLocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdvertisingLocation
        fields = '__all__'

class AdvertiserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Advertiser
        fields = '__all__'

class AdvertisementSerializer(serializers.ModelSerializer):
    locations = serializers.PrimaryKeyRelatedField(many=True, queryset=AdvertisingLocation.objects.all())
    total_ad_spend = serializers.SerializerMethodField()

    class Meta:
        model = Advertisement
        fields = '__all__'

    def get_total_ad_spend(self, obj):
        total_ad_spend = obj.ads.all().aggregate(total_spend=Sum('amount'))['total_spend']
        return total_ad_spend if total_ad_spend else 0.0
    
    def create(self, validated_data):
        locations = validated_data.pop('locations')
        advertisement = Advertisement.objects.create(**validated_data)
        for location in locations:
            AdvertisementLocation.objects.create(advertisement=advertisement, location=location)
        return advertisement

    def update(self, instance, validated_data):
        locations = validated_data.pop('locations')
        instance.title = validated_data.get('title', instance.title)
        instance.description = validated_data.get('description', instance.description)
        instance.save()

        instance.locations.clear()
        for location in locations:
            AdvertisementLocation.objects.create(advertisement=instance, location=location)
        
        return instance

class AdSpendSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdSpend
        fields = '__all__'


class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['id', 'email', 'password', 'first_name', 'last_name']

    def create(self, validated_data):
        try:
            user = User.objects.create_user(
                email=validated_data['email'],
                username=validated_data['email'],
                password=validated_data['password'],
                first_name=validated_data.get('first_name', ''),
                last_name=validated_data.get('last_name', '')
            )
        except IntegrityError:
            raise serializers.ValidationError("This email address is already in use.")

        token, _ = Token.objects.get_or_create(user=user)
        return {
            'user': {
                'id': user.id,
                'email': user.email,
                'first_name': user.first_name,
                'last_name': user.last_name
            },
            'token': token.key,
        }
