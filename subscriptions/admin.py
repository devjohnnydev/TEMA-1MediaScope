# Em subscriptions/admin.py
from django.contrib import admin
from .models import Plan, Subscription, Payment

# --- Configuração "A Nata" para o Admin ---

@admin.register(Plan)
class PlanAdmin(admin.ModelAdmin):
    list_display = ('name', 'price_monthly', 'price_annual', 'icon_name')
    search_fields = ('name',)

@admin.register(Subscription)
class SubscriptionAdmin(admin.ModelAdmin):
    list_display = ('user', 'plan', 'status', 'current_period_end')
    list_filter = ('status', 'plan') # Para filtrar por status ou plano
    search_fields = ('user__email', 'plan__name')

    # Faz o campo 'user' ser um link clicável
    raw_id_fields = ('user',)

    # --- [ADICIONE ESTE NOVO BLOCO] ---
@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = ('user', 'subscription', 'amount', 'payment_date')
    list_filter = ('payment_date',)
    search_fields = ('user__email', 'subscription__id')
    raw_id_fields = ('user', 'subscription')
# --- [FIM DA ADIÇÃO] ---