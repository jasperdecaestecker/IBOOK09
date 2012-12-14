package be.devine.cp3.model
{
    import flash.events.Event;
    import flash.events.EventDispatcher;

    public class AppModel extends EventDispatcher
    {
        private static var instance:AppModel;
        public var pageVOS:Array;
        public var pages:Array;
        public var thumbnailPages:Array;
        private var _currentPage:uint;
        private var _amountOfPages:uint;
        private var _direction:String = "next";
        private var _showTimeline:Boolean = false;

        public static const PAGE_CHANGED:String = "PageChanged";
        public static const TIMELINE_CHANGED:String = "TimelineChanged";



        public function AppModel(e:Enforcer)
        {
            if(e == null)
            {
                throw new Error("Appmodel is a singleton");
            }
        }

        public static function getInstance():AppModel
        {
            if(instance == null)
            {
                instance = new AppModel(new Enforcer());
            }
            return instance;
        }

        public function get currentPage():uint
        {
            return _currentPage;
        }

        public function set currentPage(value:uint):void
        {
            _currentPage = value;
            dispatchEvent(new Event(PAGE_CHANGED));
        }

        public function nextPage():void
        {
            if(currentPage +2 != amountOfPages)
            { direction = "next";
                currentPage += 2;

            }
        }

        public function previousPage():void
        {
            if(currentPage != 0 )
            {
                direction = "prev";
                currentPage -= 2;
            }
        }

        public function gotoPage(pageNumber:uint):void
        {
            if (currentPage < pageNumber)
            {
                direction = "next";
            }
            else
            {
                direction = "prev";
            }

            currentPage = pageNumber;

            if (currentPage%2 != 0)
            {
                currentPage = currentPage -1;
            }
        }


        public function get amountOfPages():uint
        {
            return _amountOfPages;
        }

        public function set amountOfPages(value:uint):void
        {
            _amountOfPages = value;
        }

        public function get direction():String
        {
            return _direction;
        }

        public function set direction(value:String):void
        {
            _direction = value;
        }


        public function get showTimeline():Boolean
        {
            return _showTimeline;
        }

        public function set showTimeline(value:Boolean):void
        {
            if (value != _showTimeline)
            {
                _showTimeline = value;
                dispatchEvent(new Event(TIMELINE_CHANGED));
            }
        }
    }
}

internal class Enforcer{};
