<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Note;

class NotesController extends Controller
{
    // Get notes by user_id
    public function index(Request $request)
    {
        $userId = $request->query('user_id');
        if (!$userId) {
            return response()->json(['error' => 'user_id is required'], 400);
        }

        $notes = Note::where('user_id', $userId)->get();
        return response()->json($notes);
    }

    // Create a new note
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'tugas' => 'nullable|string',
            'kegiatan' => 'nullable|string',
            'deadline' => 'required|date',
        ]);

        $note = Note::create($validated);
        return response()->json($note, 201);
    }

    // Update an existing note
    public function update(Request $request, $id)
    {
        $note = Note::find($id);
        if (!$note) {
            return response()->json(['error' => 'Note not found'], 404);
        }

        $validated = $request->validate([
            'tugas' => 'nullable|string',
            'kegiatan' => 'nullable|string',
            'deadline' => 'required|date',
        ]);

        $note->update($validated);
        return response()->json($note);
    }

    // Delete a note
    public function destroy($id)
    {
        $note = Note::find($id);
        if (!$note) {
            return response()->json(['error' => 'Note not found'], 404);
        }

        $note->delete();
        return response()->json(['message' => 'Note deleted successfully']);
    }
}
