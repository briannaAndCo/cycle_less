# pillReminder
Minimal app for birth control reminder written in flutter


### Pages
1. Home Page. Current pill package state.
     * Protection state icon.
     * Update pill state.
2. Settings Page. Current settings. 
    * Pill type settings.
    * Alarm settings.
    * App color settings.
3. Calendar Page. 
    * Icons per day.
    * Notes per day.


### TODO
- [x] pill visualization
  - [x] pill type
  - [x] pill state
- [x] link settings page
- [ ] link calendar page
- [x] create pill_pressed type to store past pill data
- [x] setup SQLite DB and CRUD
  - [x] set up pill press to insert data row
  - [x] set up pill unpress to delete data row
  - [x] set up update pill press to update data row
  - [x] read in past data and update pill package state on initalization
  - [x] update pill package state from DB when pill row changes (insert/delete)

- [ ] main page
  - [x] read in weeks and placebo days to create pill package
  - [x] update pill package on return from settings page
  - [x] popup to create pill press - has the ability to set press date/time
  - [x] popup to update/delete existing pull press - has the ability to set press date/time

- [ ] settings page
  - [x] persist data
  - [x] number of weeks
  - [x] number of placebo days
  - [x] mini pill specific setting
  - [ ] type of pill phase (mono, tri) and days per each
  - [x] continuous usage
  - [x] alarm time
    - [x] notification at alarm time
  - [ ] number of alarms
  - [ ] alarm sound
  - [ ] color palette
    - [ ] active pills (per phase)
    - [ ] inactive pills
    - [ ] taken pills
    - [ ] background 
    - [ ] icons
  
- [ ] calendar visualization
  - [ ] icons
  - [ ] notes
  
- [ ] ability to start new pack
- [x] ability to take break with no placebos
- [x] signal for protected or not
  - [x] calculation for protection
  - [x] ui for protection
  - [x] update UI when data changes
