const Rest rest = const Rest();
const SixteenthNote sixteenthNote = const SixteenthNote();

abstract class Note {
  const Note();
}

class Rest extends Note {
  const Rest();
}

class SixteenthNote extends Note {
  const SixteenthNote();
}
