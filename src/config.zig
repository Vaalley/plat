//! Centralized game configuration constants.
//! All magic numbers should be extracted here for easy tuning.

// Player Physics
pub const PLAYER_MOVE_SPEED: f32 = 200;
pub const PLAYER_JUMP_POWER: f32 = 550;
pub const PLAYER_GRAVITY: f32 = 1500;
pub const PLAYER_DASH_POWER: f32 = 800;
pub const PLAYER_DASH_COOLDOWN: f32 = 1.0;
pub const PLAYER_DASH_LOCKOUT_DURATION: f32 = 0.2;

// Player Dimensions
pub const PLAYER_HITBOX_WIDTH: f32 = 32;
pub const PLAYER_HITBOX_HEIGHT: f32 = 64;
pub const PLAYER_MAX_JUMPS: u32 = 2;

// Game Constants
pub const DEATH_Y: f32 = 800.0; // Y position below which player dies
pub const LANDING_TOLERANCE: f32 = 10.0; // Pixels tolerance for landing on OneWay/Crumbling platforms
pub const LEVEL_COMPLETION_TIMER: f32 = 3.0; // Seconds to show completion message

// Screen/Display
pub const SCREEN_WIDTH: i32 = 1280;
pub const SCREEN_HEIGHT: i32 = 720;
pub const MIN_SCREEN_WIDTH: i32 = 720;
pub const MIN_SCREEN_HEIGHT: i32 = 480;

// UI
pub const UI_DEBUG_PANEL_X: f32 = 10;
pub const UI_DEBUG_PANEL_Y: f32 = 10;
pub const UI_DEBUG_PANEL_WIDTH: f32 = 280;
pub const UI_DEBUG_LINE_HEIGHT: f32 = 20;
pub const UI_DEBUG_LINE_COUNT: i32 = 11;
pub const UI_DEBUG_PADDING: f32 = 10;
pub const UI_DEBUG_BUFFER_SIZE: i32 = 128;
pub const UI_DEBUG_HEADER_HEIGHT: f32 = 30;

pub const UI_COIN_COUNTER_X_OFFSET: i32 = 100;
pub const UI_COIN_COUNTER_Y: i32 = 10;
pub const UI_COIN_COUNTER_FONT_SIZE: i32 = 20;

pub const UI_COMPLETION_TEXT_FONT_SIZE: i32 = 40;

// Collectibles
pub const COIN_RADIUS: f32 = 10;

// Level Loading
pub const MAX_PATH_LEN: i32 = 260;
pub const MAX_LEVEL_FILE_SIZE: usize = 1024 * 1024; // 1MB
pub const COLOR_ALPHA_MAX: u8 = 255;
