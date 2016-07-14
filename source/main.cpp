/*
*  This file is part of vn3dsx
*  Copyright (C) 2016 pathway27
*
*  This program is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License
*  as published by the Free Software Foundation; either version 2
*  of the License, or (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program; if not, write to the Free Software
*  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/


#include <string.h>

#include <3ds.h>

int main()
{
  gfxInitDefault();
  //gfxSet3D(true); // uncomment if using stereoscopic 3D

  // Main loop
  while (aptMainLoop())
  {
    gspWaitForVBlank();
    hidScanInput();

    // Your code goes here

    u32 kDown = hidKeysDown();
    if (kDown & KEY_START)
      break; // break in order to return to hbmenu

    // Example rendering code that displays a white pixel
    // Please note that the 3DS screens are sideways (thus 240x400 and 240x320)
    u8* fb = gfxGetFramebuffer(GFX_TOP, GFX_LEFT, NULL, NULL);
    memset(fb, 0, 240*400*3);
    fb[3*(10+10*240)] = 0xFF;
    fb[3*(10+10*240)+1] = 0xFF;
    fb[3*(10+10*240)+2] = 0xFF;

    // Flush and swap framebuffers
    gfxFlushBuffers();
    gfxSwapBuffers();
  }

  gfxExit();
  return 0;
}
