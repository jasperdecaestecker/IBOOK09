package be.devine.cp3.ibook
{
    import be.devine.cp3.model.AppModel;
    import be.devine.cp3.service.BookService;
    import be.devine.cp3.view.NavigationBar;
    import be.devine.cp3.view.Page;
    import be.devine.cp3.view.TimeLine;
    import be.devine.cp3.vo.PageVO;
    import flash.display.StageDisplayState;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    import starling.animation.Transitions;
    import starling.animation.Tween;
    import flash.events.Event;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.KeyboardEvent;
    import starling.events.ResizeEvent;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    [SWF(frameRate=60,  backgroundColor="#e9eaeb", width="1024", height="768")]

    public class IBook extends Sprite
    {
        private var appModel:AppModel,
                    bookService:BookService,
                    pageContainer:Sprite,
                    navigationBar:NavigationBar,
                    timeLine:TimeLine,
                    bgQuad:Quad;

        public function IBook()
        {
            appModel = AppModel.getInstance();

            bgQuad = new Quad(1024, 768, 0xe9eaeb);
            addChild(bgQuad)

            Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);
            Starling.current.nativeStage.addEventListener(ResizeEvent.RESIZE,resizeHandler);

            bookService = new BookService();
            bookService.addEventListener(BookService.XML_LOADED, XMLLoadedHandler) ;
            bookService.loadBook();

            navigationBar = new NavigationBar();
            navigationBar.y = 718;
            navigationBar.addEventListener(TouchEvent.TOUCH, showTimeLine);

            addChild(navigationBar);

            pageContainer = new Sprite();
            addChild(pageContainer);

            appModel.addEventListener(AppModel.PAGE_CHANGED,pageChangedHandler);

            setChildIndex(navigationBar,numChildren-1);
        }

        private function XMLLoadedHandler(event:Event):void
        {

            appModel.pages = new Array();
            appModel.thumbnailPages = new Array();

            var countPages:uint = 0;
            for each(var pageVO:PageVO in appModel.pageVOS)
            {
                var page:Page = new Page(pageVO);
                var thumbnailPage:Page = new Page(pageVO);
                appModel.pages.push(page);
                appModel.thumbnailPages.push(thumbnailPage);
                countPages++;
            }

            timeLine= new TimeLine();
            timeLine.x = Starling.current.stage.stageWidth/2 - timeLine.width/2;
            timeLine.y = Starling.current.stage.stageHeight - timeLine.height - 27;
            addChild(timeLine);

            appModel.amountOfPages = countPages;
            appModel.currentPage = 0;
        }

    private function pageChangedHandler(event:Event):void
    {
        updatePageView();
        navigationBar.checkNextPrevious();
        navigationBar.setPageNumber();
        timeLine.updateThumbnails();

        setChildIndex(timeLine,numChildren-1);
    }

    private function updatePageView():void
    {
        if (appModel.direction == "next")
        {
            if(pageContainer.numChildren > 0)
            {
                var tweenPageContainer:Tween = new Tween(pageContainer, .5, Transitions.EASE_IN);
                tweenPageContainer.animate("x", -1024);
                tweenPageContainer.onComplete = onTweenComplete;
                tweenPageContainer.onCompleteArgs = [pageContainer];
                Starling.juggler.add(tweenPageContainer);

            }
            pageContainer = new Sprite();
            addChild(pageContainer);

            var leftPage:Sprite =  appModel.pages[appModel.currentPage];
            var rightPage:Sprite = appModel.pages[appModel.currentPage+1];
            leftPage.x = 1024;
            pageContainer.addChild(leftPage);
            var tweenPageLeft:Tween = new Tween(leftPage, .5, Transitions.EASE_IN);
            tweenPageLeft.animate("x", 0);
            Starling.juggler.add(tweenPageLeft);

            if(rightPage != null)
            {
                rightPage.x = 1024 + 512;
                pageContainer.addChild(rightPage);
                var tweenPageRight:Tween = new Tween(rightPage, .5, Transitions.EASE_IN);
                tweenPageRight.animate("x", 512);
                Starling.juggler.add(tweenPageRight);
            }

        }
        else
        {
            if(pageContainer.numChildren > 0)
            {
                var tweenPageContainer:Tween = new Tween(pageContainer, .5, Transitions.EASE_IN);
                tweenPageContainer.animate("x", 1024);
                tweenPageContainer.onComplete = onTweenComplete;
                tweenPageContainer.onCompleteArgs = [pageContainer];
                Starling.juggler.add(tweenPageContainer);

            }
            pageContainer = new Sprite();
            addChild(pageContainer);

            var leftPage:Sprite =  appModel.pages[appModel.currentPage];
            var rightPage:Sprite = appModel.pages[appModel.currentPage+1];

            leftPage.x = -1024;
            pageContainer.addChild(leftPage);
            var tweenPageLeft:Tween = new Tween(leftPage, .5, Transitions.EASE_IN);
            tweenPageLeft.animate("x", 0);
            Starling.juggler.add(tweenPageLeft);

            if(rightPage != null)
            {
                rightPage.x = -512;
                pageContainer.addChild(rightPage);
                var tweenPageRight:Tween = new Tween(rightPage, .5, Transitions.EASE_IN);
                tweenPageRight.animate("x", 512);
                Starling.juggler.add(tweenPageRight);
            }

        }

        pageContainer.addEventListener(TouchEvent.TOUCH,TouchEventHandler);
    }

    private function onTweenComplete(pageContainer:Sprite):void
    {
        removeChild(pageContainer);
    }

    private function keyboardHandler(event:KeyboardEvent):void
    {
        switch (event.keyCode)
        {
            case Keyboard.LEFT:
                appModel.previousPage();
                break;
            case Keyboard.RIGHT:
            case Keyboard.SPACE:
                appModel.nextPage();
                break;
            case Keyboard.F:
                    if(Starling.current.nativeStage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
                    {
                        Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
                    }
                    else
                    {
                        Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
                    }
                break;
        }
    }


    private function resizeHandler(event:Event):void
    {
        var x = (Starling.current.nativeStage.stageWidth - Starling.current.stage.stageWidth) >> 1;
        var y = (Starling.current.nativeStage.stageHeight - Starling.current.stage.stageHeight) >> 1;
        var currentStageHeight = Starling.current.stage.stageHeight;
        var currentStageWidth = Starling.current.stage.stageWidth;

        Starling.current.viewPort = new Rectangle(x, y, currentStageWidth, currentStageHeight);
        bgQuad.width = currentStageWidth;
        bgQuad.height = currentStageHeight;
    }

    private function showTimeLine(event:TouchEvent):void
    {
        if (event.getTouch(event.target as DisplayObject, TouchPhase.HOVER))
        {
            appModel.showTimeline = true
        }
    }

    private function TouchEventHandler(event:TouchEvent):void
    {
        var touch:Touch = event.getTouch(stage);

        if(touch.phase == "hover")
        {
            appModel.showTimeline = false;
        }
    }
}
}
