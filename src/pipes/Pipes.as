/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/25/13
 * Time: 11:59 AM
 * To change this template use File | Settings | File Templates.
 */
package pipes
{
import flash.events.EventDispatcher;

import pipes.core.config.PipeContext;

import pipes.core.service.Account;
import pipes.domain.Responder;
import pipes.events.PipelineEvent;

public class Pipes extends EventDispatcher
{
    public function Pipes()
    {
    }

    private var pipes:Object = {};

    public function get loggedIn():Boolean
    {
        return Account.account.current != null;
    }

    public function login(username:String):void
    {
        Account.account.login(username, new Responder(
            function (data:Object):void
            {
                dispatchEvent(new PipelineEvent(PipelineEvent.LOGIN));
            },
            function (info:Object):void
            {

            })
        );
    }

    public function logout():void
    {

    }

    public function get(name:String):Pipe
    {
        if (!loggedIn) return null;

        var pipe:Pipe = findPipe(name) || createPipe(name);

        pipe.getContext().activate();

        return pipe;
    }

    private function findPipe(name:String):Pipe
    {
        return pipes[name];
    }

    private function createPipe(name:String):Pipe
    {
        var info:PipeContext = new PipeContext(name);

        var pipe:Pipe = new Pipe(info);

        pipes[name] = pipe;

        return pipe;
    }

}
}
