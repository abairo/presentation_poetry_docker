import pytest
from django.test import TestCase
from django.urls import reverse
from app_messages.models import Message



@pytest.mark.django_db
def test_deve_retornar_uma_mensagem_200(client):
    mensagem = Message(text='Mensagem de Teste')
    mensagem.save()

    url = reverse('message')
    response = client.get(url)

    assert response.status_code == 200
    assert response.content