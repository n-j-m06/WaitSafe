from twilio.rest import Client

# ==============================
# TWILIO CONFIG
# ==============================
TWILIO_ACCOUNT_SID = "AC85f6895358ec8f24ad57f2aa5ccfd473"
TWILIO_AUTH_TOKEN = "e9e576997fc1ecdc9ff4bdefe52a7f66"
TWILIO_PHONE_NUMBER = "+15722216757"


# ==============================
# SEND SMS FUNCTION
# ==============================
def send_sms(phone_number: str, message: str):
    if not phone_number.startswith("+") and len(phone_number) == 10:
        phone_number = "+91" + phone_number
    try:
        client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

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