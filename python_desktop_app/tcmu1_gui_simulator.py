# ==============================================================================
# TCMU-1 UNIVERSAL GSM MOTOR CONTROLLER - PYTHON DESKTOP SIMULATOR FOR VS CODE
# Run directly in VS Code without Android Studio: python tcmu1_gui_simulator.py
# ==============================================================================
import re
import time
import json
import os

class Tcmu1ControllerSimulator:
    def __init__(self):
        self.motor_sim = "+919876543210"
        self.sticky_rate = 120.0
        self.auto_mode = True
        self.users = ["8081728811", "7839455008", "", "9236504217"]
        self.status = "STOPPED"
        self.config = {
            "cmd_start": "1*",
            "reply_start": "PUMP STARTED",
            "cmd_stop": "2*",
            "reply_stop": "PUMP STOPPED",
            "reply_timer_start": "PUMP STARTED",
            "reply_timer_end": "PUMP STOPPED",
            "reply_power_cut": "POWER OFF PUMP OFF",
            "reply_power_resume": "POWER RESUME PUMP STARTED",
            "reply_phys_start": "manual start",
            "reply_phys_stop": "manual stop",
        }

    def parse_users_sms(self, sms_text: str):
        parsed = ["", "", "", ""]
        for i in range(1, 5):
            m = re.search(rf"USER\s*{i}\s*=\s*(\d{{10,12}})", sms_text, re.IGNORECASE)
            if m:
                parsed[i - 1] = m.group(1)
        self.users = parsed
        return parsed

    def calculate_cash_memo(self, running_seconds: int, power_cut_seconds: int, manual_override: float = None):
        hours = running_seconds / 3600.0
        calc_bill = round(hours * self.sticky_rate, 2)
        final_bill = manual_override if manual_override is not None else calc_bill
        return {
            "net_running_hms": time.strftime('%H:%M:%S', time.gmtime(running_seconds)),
            "power_cut_hms": time.strftime('%H:%M:%S', time.gmtime(power_cut_seconds)),
            "rate_per_hour": self.sticky_rate,
            "calculated_bill": calc_bill,
            "final_bill": final_bill,
            "is_manual_override": manual_override is not None
        }

if __name__ == "__main__":
    sim = Tcmu1ControllerSimulator()
    print("=== TCMU-1 Universal Controller Self-Test ===")
    sample_10_reply = '''*TCMU-1 USERS*
USER1 = 8081728811,
USER2 = 7839455008,
USER4 = 9236504217.'''
    print("1. Parsed 10* Users Reply:", sim.parse_users_sms(sample_10_reply))
    print("2. Sample Cash Memo (1.5 Hr @ ₹120/hr):", json.dumps(sim.calculate_cash_memo(5400, 600), indent=2))
    print("3. Sample Cash Memo with Manual Fixed Box (₹150):", json.dumps(sim.calculate_cash_memo(5400, 600, manual_override=150.0), indent=2))
