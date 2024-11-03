# Game master UI

## Requirements

Require Eluna and AIO.
Require that you have dbc file gameobjectdisplayinfo, spellvisualeffectname inside the db. I HIGHLY RECOMMEND TO ADD EVERY DBC TO YOUR DB.

## Installation

if you have issue adding dbc to db try use [stoneharry spell editor](https://github.com/stoneharry/WoW-Spell-Editor) worked for me.

## Visual aGuide

1. Navigate to your server's `lua_scripts/AIO_Server` directory.
2. Place the `gameMasterClient.lua` and `gameMasterServer.lua` files in this directory.

Here's a visual representation:

```plaintext
lua_scripts/
└── AIO_Server/
  ├── GameMasterSystem/
  │   ├── gameMasterClient.lua
  │   └── gameMasterServer.lua
```

<div style="display: flex; gap: 10px;">
  <img src="src/assets/2024-10-20-16-04-05.png" alt="Game Master UI" style="width: 25%;">
  <img src="src/assets/2024-10-20-16-00-51.png" alt="Game Master UI1" style="width: 25%;">
  <img src="src/assets/2024-10-20-16-03-08.png" alt="Game Master UI2" style="width: 25%;">
</div>

[video new version](https://streamable.com/8qgjde)

[video old version](https://streamable.com/e76v5t)

# Search Guide for Game Objects and NPC Types

To perform a search for game object types or NPC types, you need to specify the type in parentheses (e.g., `(beast)`). Below are the available types you can use in your searches.

<table>
  <tr>
    <!-- Game Object Types Table -->
    <td style="vertical-align: top; padding-right: 20px;">

      ### Game Object Types

      To search for game object types, use the syntax `(type)`. Here’s a list of the available types:

      <table>
        <tr>
          <th>Game Object Type</th>
          <th>Value</th>
        </tr>
        <tr><td>door</td><td>0</td></tr>
        <tr><td>button</td><td>1</td></tr>
        <tr><td>questgiver</td><td>2</td></tr>
        <tr><td>chest</td><td>3</td></tr>
        <tr><td>binder</td><td>4</td></tr>
        <tr><td>generic</td><td>5</td></tr>
        <tr><td>trap</td><td>6</td></tr>
        <tr><td>chair</td><td>7</td></tr>
        <tr><td>spell focus</td><td>8</td></tr>
        <tr><td>text</td><td>9</td></tr>
        <tr><td>goober</td><td>10</td></tr>
        <tr><td>transport</td><td>11</td></tr>
        <tr><td>areadamage</td><td>12</td></tr>
        <tr><td>camera</td><td>13</td></tr>
        <tr><td>map object</td><td>14</td></tr>
        <tr><td>mo transport</td><td>15</td></tr>
        <tr><td>duel arbiter</td><td>16</td></tr>
        <tr><td>fishingnode</td><td>17</td></tr>
        <tr><td>summoning ritual</td><td>18</td></tr>
        <tr><td>mailbox</td><td>19</td></tr>
        <tr><td>do not use</td><td>20</td></tr>
        <tr><td>guardpost</td><td>21</td></tr>
        <tr><td>spellcaster</td><td>22</td></tr>
        <tr><td>meetingstone</td><td>23</td></tr>
        <tr><td>flagstand</td><td>24</td></tr>
        <tr><td>fishinghole</td><td>25</td></tr>
        <tr><td>flagdrop</td><td>26</td></tr>
        <tr><td>mini game</td><td>27</td></tr>
        <tr><td>do not use 2</td><td>28</td></tr>
        <tr><td>capture point</td><td>29</td></tr>
        <tr><td>aura generator</td><td>30</td></tr>
        <tr><td>dungeon difficulty</td><td>31</td></tr>
        <tr><td>barber chair</td><td>32</td></tr>
        <tr><td>destructible_building</td><td>33</td></tr>
        <tr><td>guild bank</td><td>34</td></tr>
        <tr><td>trapdoor</td><td>35</td></tr>
      </table>

    </td>

    <!-- NPC Types Table -->
    <td style="vertical-align: top;">

      ### NPC Types

      To search for NPC types, use the syntax `(type)`. Here’s a list of the available NPC types:

      <table>
        <tr>
          <th>NPC Type</th>
          <th>Value</th>
        </tr>
        <tr><td>none</td><td>0</td></tr>
        <tr><td>beast</td><td>1</td></tr>
        <tr><td>dragonkin</td><td>2</td></tr>
        <tr><td>demon</td><td>3</td></tr>
        <tr><td>elemental</td><td>4</td></tr>
        <tr><td>giant</td><td>5</td></tr>
        <tr><td>undead</td><td>6</td></tr>
        <tr><td>humanoid</td><td>7</td></tr>
        <tr><td>critter</td><td>8</td></tr>
        <tr><td>mechanical</td><td>9</td></tr>
        <tr><td>not specified</td><td>10</td></tr>
        <tr><td>totem</td><td>11</td></tr>
        <tr><td>non-combat pet</td><td>12</td></tr>
        <tr><td>gas cloud</td><td>13</td></tr>
        <tr><td>wild pet</td><td>14</td></tr>
        <tr><td>aberration</td><td>15</td></tr>
      </table>

    </td>
  </tr>
</table>


## Example Search Queries

- To search for NPCs of type **beast**, use: `(beast)`
- To search for a **trapdoor** game object, use: `(trapdoor)`

You can copy and paste these examples directly into your search to get the desired results. Make sure you always enclose the type in parentheses.
