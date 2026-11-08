"""Render Floripple's original music and sound cues with Python and libsndfile."""
from array import array
from ctypes import CDLL, POINTER, Structure, byref, c_char_p, c_float, c_int, c_int64, c_void_p
from ctypes.util import find_library
from math import ceil, sin, tau
from pathlib import Path

RATE = 22050
TUNES = {
    "tap": [74], "plant": [53, 65], "pulse": [65, 69, 74],
    "growth": [76, 79], "match": [77, 81], "blast": [60, 72, 77, 81],
    "combo": [67, 74, 81, 86], "echo": [74, 81, 86], "shovel": [50, 55],
    "won": [72, 76, 79, 84, 88], "lost": [69, 65, 60],
}
MUSIC = [
    60, 67, 76, 72, 67, 72, 76, 79, 57, 64, 76, 72, 64, 69, 76, 72,
    53, 60, 69, 72, 60, 65, 69, 72, 55, 62, 71, 74, 62, 67, 71, 0,
]


class StreamInfo(Structure):
    _fields_ = [("frames", c_int64), ("samplerate", c_int), ("channels", c_int),
                ("format", c_int), ("sections", c_int), ("seekable", c_int)]


def render(notes, step, release, loop=False):
    sample_count = int(RATE * (step * len(notes) + (0.0 if loop else release)))
    step_samples = int(RATE * step)
    frequencies = [440 * 2 ** ((note - 69) / 12) if note else 0 for note in notes]
    pcm = array("f")
    for sample in range(sample_count):
        value = 0.0
        last = min(len(notes) - 1, sample // step_samples)
        for n in range(max(0, last - ceil(release / step)), last + 1):
            age = (sample - n * step_samples) / RATE
            if age < release and frequencies[n]:
                phase = tau * frequencies[n] * age
                envelope = min(1.0, age * 115) * (1.0 - age / release) ** 2.8
                value += (sin(phase) + 0.23 * sin(phase * 2.01)) * envelope * 0.23
        if loop:
            value *= min(1.0, (sample_count - sample) / 4000.0)
        pcm.append(max(-1.0, min(1.0, value)))
    return pcm


def main():
    library = find_library("sndfile")
    if library is None:
        raise SystemExit("Install libsndfile with Ogg Vorbis support to render the audio.")
    sndfile = CDLL(library)
    sndfile.sf_open.argtypes = [c_char_p, c_int, POINTER(StreamInfo)]
    sndfile.sf_open.restype = c_void_p
    sndfile.sf_writef_float.argtypes = [c_void_p, POINTER(c_float), c_int64]
    sndfile.sf_writef_float.restype = c_int64
    sndfile.sf_close.argtypes = [c_void_p]
    sndfile.sf_strerror.argtypes = [c_void_p]
    sndfile.sf_strerror.restype = c_char_p

    directory = Path(__file__).resolve().parents[1] / "assets" / "audio"
    directory.mkdir(exist_ok=True)
    tracks = {key: render(notes, 0.065, 0.22) for key, notes in TUNES.items()}
    tracks["garden"] = render(MUSIC, 0.39, 0.85, loop=True)
    for name, pcm in tracks.items():
        info = StreamInfo(0, RATE, 1, 0x200060, 0, 0)  # Ogg container, Vorbis codec.
        destination = directory / f"{name}.ogg"
        stream = sndfile.sf_open(bytes(destination), 0x20, byref(info))
        if not stream:
            raise OSError(sndfile.sf_strerror(None).decode())
        samples = (c_float * len(pcm)).from_buffer(pcm)
        frames_written = sndfile.sf_writef_float(stream, samples, len(pcm))
        result = sndfile.sf_close(stream)
        if frames_written != len(pcm) or result != 0:
            raise OSError(f"Could not write {destination}")


if __name__ == "__main__":
    main()
