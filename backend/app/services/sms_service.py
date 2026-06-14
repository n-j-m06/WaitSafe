from twilio.rest import Client

# ==============================
# TWILIO CONFIG
# ==============================
TWILIO_ACCOUNT_SID = "AC85f6895358ec8f24ad57f2aa5ccfd473"
TWILIO_AUTH_TOKEN = "fddf56d17b37e2fb3b40cc0aa3a1ed7b"
TWILIO_PHONE_NUMBER = "+15722216757"


# ==============================
# SEND SMS FUNCTION
# ==============================
def send_sms(phone_number: str, message: str):
    if not phone_number.startswith("+") and len(phone_number) == 10:
        phone_number = "+91" + phone_number
    try:
        print("SID:", TWILIO_ACCOUNT_SID)
        print("TOKEN LENGTH:", len(TWILIO_AUTH_TOKEN))
        print("FROM:", TWILIO_PHONE_NUMBER)
        client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
        print(client.api.accounts(TWILIO_ACCOUNT_SID).fetch().friendly_name)

        sms = client.messages.create(
            body=message,
            from_=TWILIO_PHONE_NUMBER,
            to=phone_number,
        )

        print("SMS SENT SUCCESSFULLY:", sms.sid)

        return {
            "success": True,
            "sid": sms.sid,
            "status": sms.status,
        }

    except Exception as e:
        print("TWILIO SMS ERROR:", str(e))

        return {
            "success": False,
            "error": str(e),
        }