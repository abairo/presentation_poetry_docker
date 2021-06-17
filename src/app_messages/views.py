from django.http import HttpResponse
from .models import Message

def current_datetime(request):
    message = Message.objects.all().last()
    html = "<html><body><h1>%s</h1>.</body></html>" % message.text if message else 'Nenhuma mensagem'
    return HttpResponse(html)