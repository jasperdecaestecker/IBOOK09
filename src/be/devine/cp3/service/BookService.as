package be.devine.cp3.service
{
    import be.devine.cp3.factory.vo.PageVOFactory;
    import be.devine.cp3.model.AppModel;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class BookService extends EventDispatcher
    {
        private var _xmlLoader:URLLoader,
                    _appModel:AppModel;
        public static const XML_LOADED:String = "xmlLoaded";

        public function BookService()
        {
            _appModel = AppModel.getInstance();
        }

        public function loadBook():void
        {
            _xmlLoader = new URLLoader();
            _xmlLoader.addEventListener(Event.COMPLETE, xmlLoaderCompleteHandler);
            _xmlLoader.load(new URLRequest("assets/xml/book.xml"));
        }

        private function xmlLoaderCompleteHandler(event:Event):void
        {
            var bookXML:XML = new XML(event.target.data);
            _appModel.pages = new Array();
            for each(var pageXML:XML in bookXML.page)
            {
                _appModel.pages.push(PageVOFactory.createPageVOFromXML(pageXML));
            }
            dispatchEvent(new Event(XML_LOADED));
        }
    }
}
