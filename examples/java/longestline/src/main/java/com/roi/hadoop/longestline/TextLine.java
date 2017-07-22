/**
 * 
 */
package com.roi.hadoop.longestline;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;

/**
 * @author student
 * 
 */
public class TextLine implements Writable, Comparable<TextLine> {

	private int length;
	private String text;

	public TextLine() {
		this(0, "");
	}

	public void setLength(int length) {
		this.length = length;
	}

	public void setText(String text) {
		this.text = text;
	}

	public TextLine(int length, String text) {
		this.length = length;
		this.text = text;
	}

	public int getLength() {
		return length;
	}

	public String getText() {
		return text;
	}

	@Override
	public void readFields(DataInput in) throws IOException {
		Text t = new Text();
		t.readFields(in);
		this.text = t.toString();
		IntWritable iw = new IntWritable();
		iw.readFields(in);
		this.length = iw.get();
	}

	@Override
	public void write(DataOutput out) throws IOException {
		new Text(text).write(out);
		new IntWritable(length).write(out);
	}

	@Override
	public int compareTo(TextLine other) {
		int difflen = this.length - other.length;
		if (difflen != 0) {
			return difflen;
		}
		return text.compareTo(other.text);
	}

	@Override
	public boolean equals(Object o) {
		if (o == null || !o.getClass().equals(this.getClass())) {
			return false;
		}
		TextLine other = (TextLine) o;
		return (this.length == other.length && this.text.equals(other.text));
	}

	@Override
	public int hashCode() {
		return text.hashCode();
	}

	@Override
	public String toString() {
		return length + "(" + text + ")";
	}
}
