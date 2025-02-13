<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Location; // Ensure you import the Location model

class UserController extends Controller
{
    // Method to get the authenticated user's data
    public function getUser()
    {
        return response()->json(Auth::user());
    }

    // Method to update the authenticated user's profile
    public function update(Request $request)
    {
        $user = Auth::user();

        // Validate incoming request
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:users,email,' . $user->id,
        ]);

        // Update user fields
        $user->name = $request->name;
        $user->email = $request->email;

        $user->save();

        return response()->json(['message' => 'Profile updated successfully!']);
    }

    // Method to change the authenticated user's password
    public function changePassword(Request $request)
    {
        $user = Auth::user();

        // Validate incoming request
        $request->validate([
            'current_password' => 'required|string',
            'new_password' => 'required|string|min:8|confirmed',
        ]);

        // Check if the current password is correct
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json(['message' => 'Current password is incorrect.'], 403);
        }

        // Update the password
        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json(['message' => 'Password changed successfully!']);
    }

    // Method to update the authenticated user's location
    public function updateLocation(Request $request)
    {
        // Validate incoming request
        $request->validate([
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
        ]);

        $user = Auth::user();

        // Check if the user already has a location record
        $location = $user->location ?? new Location(); // Create a new Location if it doesn't exist

        // Update or create location fields
        $location->user_id = $user->id; // Assuming you have a user_id foreign key in your locations table
        $location->latitude = $request->latitude;
        $location->longitude = $request->longitude;
        $location->save();

        return response()->json(['message' => 'Location updated successfully!'], 200);
    }
}