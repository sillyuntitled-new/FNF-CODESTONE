function generateIcon():Void {
	switch (event.name) {
		case 'Change Character':
			if (event.params != null) {
				var group = new EventIconGroup();

				var strum = getIconFromStrumline(event.params[0]);
				if (strum != null) {
					strum.x -= 13;
					strum.x -= 6;
					strum.y -= 7;
					group.add(strum);
				}

				var char = getIconFromCharName(event.params[1]);
				if (char != null) {
					char.x += 13;
					char.x -= 6;
					char.y -= 7;
					group.add(char);
				}

				if (strum == null || char == null) {
					if (strum != null)
						char.destroy();
					if (strum != null)
						char.destroy();
					group.destroy();
					return generateDefaultIcon(event.name);
				} else return group;
			}
	}
}