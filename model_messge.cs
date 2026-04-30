using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Marathone
{
    public class model_messge
    {
        public string api_id { get; set; }
        public string api_password { get; set; }
        public string sms_type { get; set; }
        public string sms_encoding { get; set; }
        public string sender { get; set; }
        public string number { get; set; }
        public string message { get; set; }
        public string template_id { get; set; }
    }
}