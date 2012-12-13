package be.devine.cp3.view
{
    import be.devine.cp3.factory.view.TextFieldFactory;
    import be.devine.cp3.model.AppModel;

import flash.events.Event;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.display.Sprite;
import starling.events.TouchPhase;
import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    public class NavigationBar extends Sprite
    {
        [Embed(source="/assets/xml/sprite.xml", mimeType="application/octet-stream")]
        public static const ButtonXml:Class;

        [Embed(source="/assets/images/sprite.png")]
        public static const ButtonTexture:Class;



        private var appModel:AppModel,
                    buttonPrev:Button,
                    buttonNext:Button,
                    _buttonContainer:Sprite,
                    pageNumberTextfield:Sprite;

        public function NavigationBar()
        {
            appModel = AppModel.getInstance();

            var bg:Quad = new Quad(1024,50,0x182c49);
            addChild(bg);

            _buttonContainer = new Sprite();

            addChild(_buttonContainer);

            var texture:Texture = Texture.fromBitmap(new ButtonTexture);
            var xml:XML = XML(new ButtonXml());
            var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);

            buttonPrev = new Button(textureAtlas,"arrow_left.png");
            buttonPrev.addEventListener(TouchEvent.TOUCH,previous);
            _buttonContainer.addChild(buttonPrev);

            buttonNext = new Button(textureAtlas,"arrow_right.png");
            buttonNext.addEventListener(TouchEvent.TOUCH,next);
            _buttonContainer.addChild(buttonNext);

            buttonNext.x = buttonPrev.width + 200;

            _buttonContainer.x = this.width/2 - _buttonContainer.width/2;
            _buttonContainer.y = 7;

            setPageNumber();



            this.addEventListener(TouchEvent.TOUCH,TouchEventHandler);



        }

        private function previous(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(stage);

            if(touch.phase == "began")
            {
                appModel.previousPage();
            }
        }

        public function checkNextPrevious():void
        {
            if(appModel.currentPage +2 >= appModel.amountOfPages)
            {
                buttonNext.visible = false;
            }
            else
            {
                buttonNext.visible = true;
            }
            if(appModel.currentPage == 0)
            {
                buttonPrev.visible = false;
            }
            else
            {
                buttonPrev.visible = true;
            }
        }

        private function next(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(stage);

            if(touch.phase == "began")
            {
                appModel.nextPage();
            }
        }

        public function setPageNumber():void
        {
            if (pageNumberTextfield != null)
            {
                this.removeChild(pageNumberTextfield);
            }

                var pageLeft:uint = appModel.currentPage + 1
                var pageRight:uint = appModel.currentPage + 2;
                pageNumberTextfield = TextFieldFactory.createTextField({
                    text: "Page  " + pageLeft.toString() + " - " + pageRight.toString() ,
                    fontFormat: "p-normal-white"
                });

                pageNumberTextfield.x = Starling.current.stage.stageWidth - 100;
            pageNumberTextfield.y = 3;
                addChild(pageNumberTextfield);
        }


        private function TouchEventHandler(event:TouchEvent):void
        {
            event.getTouch(event.target as DisplayObject, TouchPhase.HOVER) ?  appModel.showTimeline = true :  appModel.showTimeline = false;
            /*var touch:Touch = event.getTouch(stage);

            if(touch.phase == "hover")
            {
                trace("[NavigationBar] hoverOVer");
                appModel.showTimeline = true;
            }  */

        }
    }
}
