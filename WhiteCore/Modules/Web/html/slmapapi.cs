﻿using WhiteCore.Framework;
using WhiteCore.Framework.Servers.HttpServer;
using System.Collections.Generic;
using WhiteCore.Framework.Servers.HttpServer.Implementation;
using WhiteCore.Framework.Services;

namespace WhiteCore.Modules.Web
{
    public class SLMapAPIPage : IWebInterfacePage
    {
        public string[] FilePath
        {
            get
            {
                return new[]
                           {
                               "html/map/slmapapi.js"
                           };
            }
        }

        public bool RequiresAuthentication
        {
            get { return false; }
        }

        public bool RequiresAdminAuthentication
        {
            get { return false; }
        }

        public Dictionary<string, object> Fill(WebInterface webInterface, string filename, OSHttpRequest httpRequest,
                                               OSHttpResponse httpResponse, Dictionary<string, object> requestParameters,
                                               ITranslator translator, out string response)
        {
            response = null;
            var vars = new Dictionary<string, object>();

            IGridServerInfoService infoService = webInterface.Registry.RequestModuleInterface<IGridServerInfoService>();

            string mapService = infoService.GetGridURI("MapService");
            string mapAPIService = infoService.GetGridURI("MapAPIService");

            vars.Add("WorldMapServiceURL", mapService.Remove(mapService.Length - 1));
            vars.Add("WorldMapAPIServiceURL", mapAPIService.Remove(mapAPIService.Length - 1));

            return vars;
        }

        public bool AttemptFindPage(string filename, ref OSHttpResponse httpResponse, out string text)
        {
            text = "";
            return false;
        }
    }
}