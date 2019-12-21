/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/26/13
 * Time: 4:01 PM
 * To change this template use File | Settings | File Templates.
 */
package pipes.core.remoting.impl
{
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;

import pipes.domain.Response;
import pipes.domain.Token;

public class DefaultOperation
{
    public function DefaultOperation(url:String)
    {
        super();

        this.url = url;
    }

    private var url:String;

    public function get():Token
    {
        return invoke(URLRequestMethod.GET, null);
    }

    public function post(data:Object):Token
    {
        return invoke(URLRequestMethod.POST, data);
    }

    public function invoke(method:String, data:Object):Token
    {
        var token:Token = new Token();

        var completeHandler:Function = function(event:Event):void
        {
            loader.removeEventListener(Event.COMPLETE, completeHandler);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);

            token.applyResult(JSON.parse(loader.data as String));
        };

        var errorHandler:Function = function(event:ErrorEvent):void
        {
            loader.removeEventListener(Event.COMPLETE, completeHandler);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);

            token.applyFault(event.text);
        };

        var loader:URLLoader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, completeHandler);
        loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);

        var request:URLRequest = new URLRequest(url)
        request.method = method;
        request.contentType = "application/json";

        if (data) request.data = JSON.stringify(data);

        loader.load(request);

        return token;
    }
}
}
