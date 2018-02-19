with Ada.Command_Line;
with Ada.Text_IO;
--  with Ada.Unchecked_Conversion;
--  with Interfaces.C.Pointers;
with SDL;
with SDL.Error;
with SDL.Events.Events;
with SDL.Events.Keyboards;
with SDL.Log;
with SDL.TTFs.Makers;
with SDL.Video.Palettes;
with SDL.Video.Pixel_Formats;
--  with SDL.Video.Pixels;
with SDL.Video.Rectangles;
--  with SDL.Video.Renderers.Makers;
--  with SDL.Video.Textures.Makers;
with SDL.Video.Surfaces;
with SDL.Video.Windows.Makers;
with SDL.Versions;
with System;
with System.Address_To_Access_Conversions;

procedure TTF is
   W              : SDL.Video.Windows.Window;
   Window_Surface : SDL.Video.Surfaces.Surface;
--     Renderer       : SDL.Video.Renderers.Renderer;
   Font           : SDL.TTFs.Fonts;
   Text_Surface   : SDL.Video.Surfaces.Surface;
--     Text_Texture   : SDL.Video.Textures.Texture;
begin
   if Ada.Command_Line.Argument_Count = 0 then
      Ada.Text_IO.Put_Line ("Error! Enter TTF font path on command line.");
   else
      SDL.Log.Set (Category => SDL.Log.Application, Priority => SDL.Log.Debug);

      if SDL.Initialise (Flags => SDL.Enable_Screen) = True and then SDL.TTFs.Initialise = True then
         SDL.Video.Windows.Makers.Create (Win      => W,
                                          Title    => "TTF (Esc to exit)",
                                          Position => SDL.Natural_Coordinates'(X => 100, Y => 100),
                                          Size     => SDL.Positive_Sizes'(800, 640),
                                          Flags    => SDL.Video.Windows.Resizable);

--           SDL.Video.Renderers.Makers.Create (Renderer, W);

         Window_Surface := W.Get_Surface;

         --  SDL.TTFs.Makers.Create (Font, "/home/laguest/.fonts/Belga.ttf", 24);
         SDL.TTFs.Makers.Create (Font, Ada.Command_Line.Argument (1), 36);

         Text_Surface := Font.Render_Solid (Text   => "Hello from SDLAda",
                                            Colour => SDL.Video.Palettes.Colour'(Alpha => 255, others => 0));

         Text_Surface.Set_Blend_Mode (SDL.Video.None);
--           Text_Surface := Font.Render_Shaded (Text              => "Hello from SDLAda",
--                                               Colour            => SDL.Video.Palettes.Colour'(others => 255),
--                                               Background_Colour => SDL.Video.Palettes.Colour'(0, 0, 0, 0));

--           Text_Surface := Font.Render_Blended (Text   => "Hello from SDLAda",
--                                                Colour => SDL.Video.Palettes.Colour'(others => 255));

--           SDL.Video.Textures.Makers.Create (Text_Texture, Renderer, Text_Surface);

         Window_Surface.Blit (Source => Text_Surface);

         W.Update_Surface;

         --  Main loop.
         declare
            Event            : SDL.Events.Events.Events;
            Finished         : Boolean := False;

            use type SDL.Events.Event_Types;
            use type SDL.Events.Keyboards.Key_Codes;
--            use type SDL.Events.Keyboards.Scan_Codes;
         begin
            --  W.Update_Surface;  --  Shows the above two calls.
            loop
               while SDL.Events.Events.Poll (Event) loop
                  case Event.Common.Event_Type is
                  when SDL.Events.Quit =>
                     Finished := True;

                  when SDL.Events.Keyboards.Key_Down =>
                     if Event.Keyboard.Key_Sym.Key_Code = SDL.Events.Keyboards.Code_Escape then
                        Finished := True;
                     end if;

                  when others =>
                     null;
                  end case;
               end loop;

--                 Renderer.Clear;
--                 Renderer.Copy (Text_Texture);
--                 Renderer.Present;

               exit when Finished;
            end loop;
         end;

         SDL.Log.Put_Debug ("");

         --  Window_Surface.Finalize;
         W.Finalize;

         SDL.TTFs.Finalise;
         SDL.Finalise;
      else
         Ada.Text_IO.Put_Line ("Error! could not initialise SDL or SDL.TTF!");
      end if;
   end if;
end TTF;
