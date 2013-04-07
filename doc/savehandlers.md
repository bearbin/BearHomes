BearHomes SaveHandler API
=========================

API version 1

Required Functions
------------------

There are 5 required functions:

 1. An init function. This allows you to set up values on startup, as there must be no code outside of functions.
 2. A home loader function.
 3. A home saver function.
 4. A home deletion function.
 5. A home list function.
 6. A function that returns the other functions.
 7. A function to be called on disablement.

### General Function Rules

 * All functions must be in all CAPS.
 * All functions must be prefixed with your handler name (for example INISAVELOAD, INISAVESAVE, INISAVEINIT, etc).

### Init

This can be called whatever you like and can do whatever you like.

#### Parameters

None

#### Return Values

 1. Success (bool). `true` if successful and `false` otherwise.
 2. Error Message (string). The message if there was an error, `nil` if there was no error.

### Disable

This is called when the server is shutting down.

#### Parameters

None

#### Return Values

None

### Home Loader

This can be called whatever you like and gives the coordinates of a home to be saved.

#### Paramaters

 1. Name of player for home to be fetched.
 2. Name of the home of that player.

#### Return Values

 1. Success (bool). `true` if successful and `false` otherwise.
 2. Error Message (string). The message if there was an error, `nil` if there was no error.
 3. X Coordinate (number). The x coordinate for the selected home. `nil` if there was an error.
 4. Y Coordinate (number). The y coordinate for the selected home. `nil` if there was an error.
 5. Z Coordinate (number). The z coordinate for the selected home. `nil` if there was an error.

### Home Saver

This can be called whatever you like and takes a new home to save.

It must overwrite any homes previously saved under the same name.

#### Parameters

 1. Player (string). Name of the player who will own the home.
 2. Home Name (string).
 3. X Coordinate (number). The x coordinate of the home. 
 4. Y Coordinate (number). The y coordinate of the home. 
 5. Z Coordinate (number). The z coordinate of the home. 

#### Return Values

 1. Success (bool). `true` if successful and `false` otherwise.
 2. Error Message (string). The message if there was an error, `nil` if there was no error.

### Home Deletion

Deletes the set home.

#### Parameters

 1. Player (string). Name of the player who owns the home.
 2. Home Name (string). Blank home names must be accepted also. `'*'` must be accepted as a name to delete all homes.

#### Return Values

 1. Success (bool). `true` if successful and `false` otherwise.
 2. Error Message (string). The message if there was an error, `nil` if there was no error.

### Home List

Gets a list of all the homes of a player.

#### Parameters

 1. Player (string). Name of the player who owns the homes.

#### Return Values

 1. Success (bool). `true` if successful and `false` otherwise.
 2. Error Message (string). The message if there was an error, `nil` if there was no error.
 3. Homes (list). The names of the homes of the user, in a list. This is just an empty list if the player does not have any homes.

### Setup / Main Function

This returns the other functions so they can be called by the main plugin.

#### Parameters

None

#### Return Values

 1. API Version (number). The API version that your save handler supports.
 2. Init (function). The Init function.
 3. Home Save (function). The home saver function.
 4. Home Load (function). The home loader function.
 5. Home List (function). The home list function.
 6. Home Delete (function). The home deletion function.
 7. Disable (function). The disable function.
