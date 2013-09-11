AdminUser.create!(:email => 'yannis.jaquet@unige.ch', :password => '12345678', :password_confirmation => '12345678')

# TYPE = ['organisation', 'student presentation', 'keynote presentation', 'break']
events = [
  {
    title: 'Registration',
    start: "2014-02-13 08:30",
    end: "2014-02-13 10:00",
    kind: "organisation"
  },
  {
    title: 'Welcome',
    start: "2014-02-13 10:00",
    end: "2014-02-13 10:15",
    kind: "organisation"
  },
  {
    title: 'Invited speaker: Prof. J. Leake',
    start: "2014-02-13 10:15",
    end: "2014-02-13 11:00",
    kind: "keynote presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 11:00",
    end: "2014-02-13 11:15",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 11:15",
    end: "2014-02-13 11:30",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 11:30",
    end: "2014-02-13 11:45",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 11:45",
    end: "2014-02-13 12:00",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 12:00",
    end: "2014-02-13 12:15",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 12:15",
    end: "2014-02-13 12:30",
    kind: "student presentation"
  },
  {
    title: 'lunch',
    start: "2014-02-13 12:30",
    end: "2014-02-13 13:45",
    kind: "break"
  },
  {
    title: 'Invited speaker: Prof.  B. Ibelings',
    start: "2014-02-13 13:45",
    end: "2014-02-13 14:30",
    kind: "keynote presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 14:30",
    end: "2014-02-13 14:45",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 14:45",
    end: "2014-02-13 15:00",
    kind: "student presentation"
  },
  {
    title: 'coffee break + Poster session',
    start: "2014-02-13 15:00",
    end: "2014-02-13 15:45",
    kind: "break"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 15:45",
    end: "2014-02-13 16:00",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 16:00",
    end: "2014-02-13 16:15",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 16:15",
    end: "2014-02-13 16:30",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 16:30",
    end: "2014-02-13 16:45",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 16:45",
    end: "2014-02-13 17:00",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 17:00",
    end: "2014-02-13 17:15",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-13 17:15",
    end: "2014-02-13 17:30",
    kind: "student presentation"
  },
  {
    title: "Darwin's Dinner",
    start: "2014-02-13 19:00",
    end: "2014-02-13 23:00",
    kind: "break"
  },
  {
    title: 'Conference: Prof. P.H. Gouyon',
    start: "2014-02-13 20:00",
    end: "2014-02-13 20:45",
    kind: "keynote presentation"
  },
  ######## next day
  {
    title: 'Registration',
    start: "2014-02-14 08:30",
    end: "2014-02-14 09:30",
    kind: "organisation"
  },
  {
    title: 'Invited speaker:  Prof. D. Tautz',
    start: "2014-02-14 09:30",
    end: "2014-02-14 10:15",
    kind: "keynote presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 10:15",
    end: "2014-02-14 10:30",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 10:30",
    end: "2014-02-14 10:45",
    kind: "student presentation"
  },
  {
    title: 'coffee break + Poster session',
    start: "2014-02-14 10:45",
    end: "2014-02-14 11:30",
    kind: "break"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 11:30",
    end: "2014-02-14 11:45",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 11:45",
    end: "2014-02-14 12:00",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 12:00",
    end: "2014-02-14 12:15",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 12:15",
    end: "2014-02-14 12:30",
    kind: "student presentation"
  },
  {
    title: 'lunch',
    start: "2014-02-14 12:30",
    end: "2014-02-14 13:45",
    kind: "break"
  },
  {
    title: 'Invited speaker: Prof. A. Antonelli',
    start: "2014-02-14 13:45",
    end: "2014-02-14 14:30",
    kind: "keynote presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 14:30",
    end: "2014-02-14 14:45",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 14:45",
    end: "2014-02-14 15:00",
    kind: "student presentation"
  },
  {
    title: 'Coffee break + Poster session',
    start: "2014-02-14 15:00",
    end: "2014-02-14 15:45",
    kind: "break"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 15:45",
    end: "2014-02-14 16:00",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 16:00",
    end: "2014-02-14 16:15",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 16:15",
    end: "2014-02-14 16:30",
    kind: "student presentation"
  },
  {
    title: 'student presentation',
    start: "2014-02-14 16:30",
    end: "2014-02-14 16:45",
    kind: "student presentation"
  },
  {
    title: 'Senior presentation (not in competition)',
    start: "2014-02-14 16:45",
    end: "2014-02-14 17:00",
    kind: "student presentation"
  },
  {
    title: 'Prices and Farewell',
    start: "2014-02-14 17:00",
    end: "2014-02-14 17:30",
    kind: "organisation"
  }
]

for event in events
  Event.create title: event[:title], start: event[:start], end: event[:end], kind: event[:kind]
end
